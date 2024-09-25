"use server";
// import { PrismaClient } from "@prisma/client";
import { SignJWT, jwtVerify } from "jose";
import { cookies } from "next/headers";
import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import bcryptjs from "bcryptjs";
import { revalidatePath, revalidateTag } from "next/cache";
import { ZodError } from "zod";
import uri from "./uri";
// import { UserSession } from "@/app/dashboard/components/context";

const secretKey = process.env.SECRET_KEY;
const key = new TextEncoder().encode(secretKey);

const setCookie = async (session: string, expires: Date) => {
  const isProduction = process.env.NODE_ENV === "production";
  cookies().set("session", session, {
    expires,
    httpOnly: true,
    secure: isProduction,
  });
};
//encryt our token
export const encrypt = async (payload: any) => {
  return await new SignJWT(payload)
    .setProtectedHeader({ alg: "HS256" })
    .setIssuedAt()
    .setExpirationTime("30 days from now")
    .sign(key);
};

// decrypt our token
export const decrypt = async (input: string): Promise<any> => {
  const { payload } = await jwtVerify(input, key, {
    algorithms: ["HS256"],
  });
  return payload;
};

export const loginAction = async (
  prevState: {
    message: string;
  },
  formData: FormData
) => {
  try {
    const schema = z.object({
      mobile: z
        .string()
        .min(9, {
          message: "يجب ادخال رقم هاتفك الحقيقي",
        })
        .max(10, {
          message: "يجب ادخال رقم هاتفك الحقيقي",
        }),
      password: z.string().min(6, {
        message: "يجب ان تحوي كلمة السر على ست علامات على الأقل",
      }),
    });
    const data = schema.parse({
      mobile: formData.get("mobile"),
      password: formData.get("password"),
    });

    if (!data) {
      return { message: "يجب ملء جميع الحقول" };
    }

    const { password, mobile } = data;
    // const mobile = Number(formatPhoneNumber(data.mobile));

    const expires = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000);
    const newUser = await loginRequest({
      user: {
        mobile: Number(mobile),
        password,
      },
    });
    if (!newUser) {
      return { message: "حدث خطا" };
    }
    if (!newUser.user) {
      return { message: "لم يتم ايجاد بيانات المستخدم" };
    }

    const session = await encrypt({
      ...{
        id: newUser.user.id,
        fullName: newUser.user.fullName,
        phone: newUser.user.mobile,
        status: newUser.user.status,
        role: newUser.user.role,
        token: newUser.user.token,
      },

      expires,
    });
    // Save the session in a cookie
    setCookie(session, expires);
    return { message: "تم تسجيل الدخول بنجاح" };
    // return cookies().set("session", session, { expires, httpOnly: true });
  } catch (error) {
    console.log(error);
    if (error instanceof ZodError) {
      const firstError = error.errors[0]?.message || "فشل تسجيل الدخول";
      return { message: firstError };
    } else {
      console.log(error);
      return { message: "فشل تسجيل الدخول" };
    }
  }
};

export const loginRequest = async ({
  user,
}: {
  user: {
    mobile: number;
    password: string;
  };
}): Promise<{ message: string; user?: User }> => {
  try {
    const res = await fetch(`${uri}/auth/login`, {
      method: "POST",
      body: JSON.stringify(user),
      headers: {
        "Content-Type": "application/json", // Add the Content-Type header
      },
    });
    console.log(JSON.stringify(user));
    const data: { data: User; message: string } = await res.json();

    if (!data) {
      return { message: "حدث خطأ أثناء إنشاء المنتج" };
    }

    revalidatePath("/");

    return { message: data.message, user: data.data };
  } catch (error) {
    return { message: "حدث خطأ" };
  }
};

// export const logout = async () => {
//   // Destroy the session
//   try {
//     cookies().set("session", "", { expires: new Date(0) });
//     // revalidatePath("/");
//     return { message: "تم تسجيل الخروج بنجاح" };
//   } catch (error) {
//     return { message: "حدث خطأ أثناء تسجيل الخروج" };
//   }
// };
// /**
//  * Fetches the current user session from the server.
//  * @returns {Promise<UserSession | null>} A promise that resolves to the user session or null if no session exists.
//  */
// export const getSession = async (): Promise<UserSession | null> => {
//   const session = cookies().get("session")?.value;
//   if (!session) return null;
//   return await decrypt(session);
// };

/**
 * Fetches the current user session from the server.
 * @returns {Promise<UserSession | null>} A promise that resolves to the user session or null if no session exists.
 */
export const getSession = async (): Promise<UserSession | null> => {
  const session = cookies().get("session")?.value;
  if (!session) return null;
  return await decrypt(session);
};
export const updateSession = async (request: NextRequest) => {
  const session = request.cookies.get("session")?.value;
  if (!session) return;

  // Refresh the session so it doesn't expire
  const parsed = await decrypt(session);
  parsed.expires = new Date(Date.now() + 1 * 24 * 60 * 60 * 1000);
  const res = NextResponse.next();
  res.cookies.set({
    name: "session",
    value: await encrypt(parsed),
    httpOnly: true,
    expires: parsed.expires,
  });
  return res;
};
