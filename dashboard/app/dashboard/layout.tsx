import NavigationRail from "./components/naviagation-rail";
import "../globals.css";
import { Metadata } from "next";
import { revalidateTag } from "next/cache";
import DoNotRenderIf from "./components/do-not-render";
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
  // revalidateTag("products");
  // revalidateTag("categories");

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
