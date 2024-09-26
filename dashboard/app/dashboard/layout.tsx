import "../globals.css";
import NavigationRail from "./components/naviagation-rail";
import { Metadata } from "next";
import DoNotRenderIf from "./components/do-not-render";
import { getSession } from "@/lib/auth";
import { redirect } from "next/navigation";

export const metadata: Metadata = {
  title: {
    default: "لوحة التحكم",
    template: "%s < لوحة التحكم < الإتحاد الوطني",
  },
};
const DashboardLayout = async ({ children }: { children: React.ReactNode }) => {
  const user = await getSession();
  if (!user) {
    redirect("/sign-in");
  }
  if (user && user.role !== "admin") {
    redirect("/sign-in");
  }

  return (
    <main
      className="flex relative flex-start gap-1 min-h-screen bg-secondary"
      dir="rtl"
    >
      <DoNotRenderIf conditionLable="print">
        <section className=" bg-white">
          <NavigationRail />
        </section>
      </DoNotRenderIf>
      <section className="flex-1 bg-secondary max-w-full">
        {/* <Header /> */}
        <>{children}</>
      </section>
    </main>
  );
};
export default DashboardLayout;
