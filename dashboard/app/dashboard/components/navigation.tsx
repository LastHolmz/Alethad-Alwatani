"use client";
import { usePathname } from "next/navigation";
import Link from "next/link";
import { cn } from "@/lib/utils";
import { buttonVariants } from "@/lib/constant";

interface TabLinkProps {
  href: string;
  content: string;
  className?: string;
}

export default function NavigationTabs({
  children,
  className,
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <nav
      className={cn(
        "flex flex-row justify-start flex-wrap gap-1 px-4 py-2 bg-background",
        className
      )}
      dir="rtl"
    >
      {children}
    </nav>
  );
}

export function TabLink({ href, content, className }: TabLinkProps) {
  const pathname = usePathname();
  return (
    <div className="relative w-fit my-1">
      <Link
        className={cn(
          className,
          "flex-center text-sm  h-12 px-4 transition-all py-2 rounded-sm",
          pathname.startsWith(href)
            ? "text-primary"
            : "dark:text-white text-black hover:bg-orange-200"
        )}
        href={href}
      >
        {content}
      </Link>
      <div
        className={cn(
          "h-0.5 w-full transition-all rounded-t-lg",
          pathname.startsWith(href) && "bg-primary"
        )}
      />
    </div>
  );
}
export function HomeTabLink({ href, content, className }: TabLinkProps) {
  const pathname = usePathname();
  return (
    <div className="relative my-1 w-fit">
      <Link
        className={cn(
          className,
          "flex-center text-sm  h-12 px-4 transition-all py-2 rounded-sm",
          pathname === `${href}`
            ? "text-primary"
            : "dark:text-white text-black hover:bg-orange-200"
        )}
        href={href}
      >
        {content}
      </Link>
      <div
        className={cn(
          "h-0.5 w-full transition-all rounded-t-lg",
          pathname === `${href}` && "bg-primary"
        )}
      />
    </div>
  );
}

export function TabLinkNav({ href, content, className }: TabLinkProps) {
  const pathname = usePathname();
  return (
    <div className="relative w-fit">
      <Link
        className={cn(
          className,

          "h-12 text-sm px-4 text-center transition-all hover:text-primary w-full rounded-lg ",
          buttonVariants.default,
          buttonVariants.variants.size.sm,
          buttonVariants.variants.variant.outline,
          pathname === href && "text-primary"
        )}
        href={href}
      >
        {content}
      </Link>
      <div
        className={cn(
          "h-0.5 w-full transition-all rounded-t-lg",
          pathname.startsWith(href) && "bg-primary"
        )}
      />
    </div>
  );
}
export function HomeTabLinkNav({ href, content, className }: TabLinkProps) {
  const pathname = usePathname();
  return (
    <div className="relative my-1 w-full">
      <Link
        className={cn(
          className,

          "h-12 text-sm px-4 text-center transition-all hover:text-primary rounded-lg w-full",
          buttonVariants.default,
          buttonVariants.variants.size.sm,
          buttonVariants.variants.variant.outline,
          pathname === href && "text-primary"
        )}
        href={href}
      >
        {content}
      </Link>
      {/*       <div
        className={cn(
          "h-0.5 w-full transition-all rounded-t-lg",
          pathname === `${href}` && "bg-primary"
        )}
      /> */}
    </div>
  );
}
