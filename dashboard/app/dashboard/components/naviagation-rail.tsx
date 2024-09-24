"use client";
import { Sidebar, Menu, sidebarClasses } from "react-pro-sidebar";
import React from "react";
import Link from "next/link";
import { Button } from "@/components/ui/button";
import { FaBars } from "react-icons/fa";
import { usePathname } from "next/navigation";
import { cn } from "@/lib/utils";
import { FaUsers } from "react-icons/fa";
import { RxDashboard } from "react-icons/rx";
import { AiFillProduct } from "react-icons/ai";
import { FaMoneyCheckAlt } from "react-icons/fa";
import { MdCategory, MdLocalOffer } from "react-icons/md";
import { FaCodePullRequest, FaUserDoctor } from "react-icons/fa6";
import { TfiLayoutMediaCenter } from "react-icons/tfi";
import { MdOutline6FtApart } from "react-icons/md";
import { GiMuscleUp } from "react-icons/gi";
import { SiStatista } from "react-icons/si";

import { buttonVariants } from "@/lib/constant";
import { TbReportSearch } from "react-icons/tb";
import { IconType } from "react-icons/lib";

const NavigationRailItem = ({
  pathname,
  href,
  collapsed,
  Icon,
  name,
}: {
  pathname: string;
  href: string;
  collapsed: boolean;
  Icon: IconType;
  name: string;
}) => {
  return (
    <Link
      aria-label={name}
      className={`flex justify-center transition-all rounded-[0px] items-center w-full gap-1 sm:gap-2 ${
        pathname === href || pathname.startsWith(`${href}/`)
          ? buttonVariants.variants.variant.secondary
          : `${buttonVariants.variants.variant.outline} border-0`
      }   ${buttonVariants.variants.size.default}`}
      href={href}
    >
      <div>{!collapsed && <span>{name}</span>}</div>
      <div>
        <Icon />
      </div>
    </Link>
  );
};
const NavigationRailHomeItem = ({
  pathname,
  href,
  collapsed,
  Icon,
  name,
}: {
  pathname: string;
  href: string;
  collapsed: boolean;
  Icon: IconType;
  name: string;
}) => {
  return (
    <Link
      className={`flex justify-center transition-all rounded-[0px] items-center w-full gap-1 sm:gap-2 ${
        pathname === href
          ? buttonVariants.variants.variant.secondary
          : `${buttonVariants.variants.variant.outline} border-0`
      }   ${buttonVariants.variants.size.default}`}
      href={href}
    >
      <div>{!collapsed && <span>{name}</span>}</div>
      <div>
        <Icon />
      </div>
    </Link>
  );
};

const NavigationRail = () => {
  const pathname = usePathname();
  const [collapsed, setCollapsed] = React.useState<boolean>(true);
  return (
    <Sidebar
      rootStyles={{
        [`.${sidebarClasses.container}`]: {
          backgroundColor: "hsl(var(--background))",
        },
      }}
      rtl
      className=" fixed top-0 right-0 bg-background h-screen"
      collapsed={collapsed}
    >
      <Button
        dir="rtl"
        size={"icon"}
        variant={"ghost"}
        className={cn(
          "absolute left-2 transition-all top-2",
          collapsed && "right-1/4"
        )}
        onClick={() => setCollapsed(!collapsed)}
      >
        <FaBars />
      </Button>
      <Menu className=" mt-20 ">
        <NavigationRailHomeItem
          pathname={pathname}
          collapsed={collapsed}
          href="/dashboard"
          Icon={SiStatista}
          name="لوحة التحكم"
        />
        <NavigationRailItem
          pathname={pathname}
          collapsed={collapsed}
          href="/dashboard/products"
          Icon={AiFillProduct}
          name="المنتجات"
        />
        <NavigationRailItem
          pathname={pathname}
          collapsed={collapsed}
          href="/dashboard/categories-brands"
          Icon={MdCategory}
          name="الأصناف و البراندات"
        />
        <NavigationRailItem
          pathname={pathname}
          collapsed={collapsed}
          href="/dashboard/users"
          Icon={FaUsers}
          name="المستخدمين"
        />
        <NavigationRailItem
          pathname={pathname}
          collapsed={collapsed}
          href="/dashboard/orders"
          Icon={MdLocalOffer}
          name="الفواتير"
        />
      </Menu>
    </Sidebar>
  );
};

export default NavigationRail;
