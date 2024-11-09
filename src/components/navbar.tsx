import { AirVent } from "lucide-react";
import Link from "next/link";
import { Button, buttonVariants } from "./ui/button";
import { getServerSession } from "@/actions/session";
import { signOut } from "@/actions/auth";

export default async function Navbar() {

  const session = await getServerSession();

  return (
    <nav className="border-b px-4">
      <div className="flex items-center justify-between mx-auto max-w-4xl h-16">
        <Link href='/' className="flex items-center gap-2">
          <AirVent className="h-6 w-6" />
          <span className="font-bold">boilerplate.</span>
        </Link>

        <div>
          {
            session ? (
              <form action={signOut}>
                <Button type='submit'>Salir</Button>
              </form>
            ) : 
            <Link href='/ingresar' className={buttonVariants()}>
              Iniciar sesión
            </Link>
          }
        </div>
      </div>
    </nav>
  )
}
