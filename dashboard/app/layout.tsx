"use client";
import "./globals.css";
import { redirect, usePathname } from "next/navigation";
import { Noto_Sans_Arabic } from "next/font/google";

import { Toaster } from "@/components/ui/toaster";
import { cn } from "@/lib/utils";

const notoNaskhArabic = Noto_Sans_Arabic({
  weight: "500",
  subsets: ["arabic"],
  display: "swap",
});
// export const metadata: Metadata = {
//   title: "Create Next App",
//   description: "Generated by create next app",
// };

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const pathname = usePathname();
  if (!pathname.includes("dashboard")) {
    redirect("/dashboard");
  }
  return (
    <html suppressHydrationWarning lang="en" dir="rtl">
      <body className={cn(notoNaskhArabic.className)}>
        {children}
        <Toaster />
      </body>
    </html>
  );
}
