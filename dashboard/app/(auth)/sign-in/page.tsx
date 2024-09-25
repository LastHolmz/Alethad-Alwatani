import { Metadata } from "next";
import { SignInForm } from "../component/forms";
export const metadata: Metadata = {
  title: "تسجيل الدخول",
  description: "سجل دخولك في our gym",
};
const page = async ({
  searchParams,
}: {
  searchParams?: { redirect?: string };
}) => {
  return (
    <div className="w-full h-full">
      <h1 className=" font-bold md:mb-10 md:mt-0 my-4 text-xl  sm:text-3xl w-full text-center ">
        تسجيل الدخول
      </h1>
      <SignInForm redirectTo={searchParams?.redirect} />
    </div>
  );
};

export default page;
