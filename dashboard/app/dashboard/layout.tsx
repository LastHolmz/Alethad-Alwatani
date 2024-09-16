import NavigationRail from "./components/naviagation-rail";
import "../globals.css";
import { Metadata } from "next";
// import Header from "./components/header";
// import { redirection } from "@/lib/role-access-server";

export const metadata: Metadata = {
  title: {
    default: "لوحة التحكم",
    template: "%s < لوحة التحكم < الإتحاد الوطني",
  },
};
const DashboardLayout = async ({ children }: { children: React.ReactNode }) => {
  //   await redirection({
  //     accessbleRoles: [
  //       "doctor",
  //       "employee",
  //       "reception",
  //       "superAdmin",
  //       "patient",
  //       "trainer",
  //     ],
  //     redirectLink: "/sign-in",
  //   });

  return (
    <main
      className="flex relative flex-start gap-1 min-h-screen bg-secondary"
      dir="rtl"
    >
      <section className=" bg-white">
        <NavigationRail />
      </section>
      <section className="flex-1 bg-secondary max-w-full">
        {/* <Header /> */}
        <>{children}</>
      </section>
    </main>
  );
};
export default DashboardLayout;
