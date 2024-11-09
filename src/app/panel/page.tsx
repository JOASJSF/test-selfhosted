import { getServerSession } from "@/actions/session"

export default async function PanelPage() {
  const session = await getServerSession();
  const user = session?.user;

  return (
    <div className="mt-10 text-center">
        <h1>Panel de control</h1>
        <h2>Nombre: {user?.name}</h2>
        <h2>Nombre: {user?.email}</h2>
    </div>
  )
}
