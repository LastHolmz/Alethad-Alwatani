"use client";

import { Dispatch, SetStateAction, Suspense, useState } from "react";
import { UploadDropzone } from "./upload";
import { Skeleton } from "@/components/ui/skeleton";
import { Button } from "@/components/ui/button";
import { MdOutlineCancel } from "react-icons/md";
import Image from "next/image";
import { Label } from "@/components/ui/label";
import { toast } from "@/components/ui/use-toast";
import { Input } from "@/components/ui/input";
import { cn } from "@/lib/utils";
interface Props {
  title?: string;
  name?: string;
  className?: string;
  defautlImage?: string;
}
const ImageDropzone = ({
  title,
  name,
  className,
  defautlImage = "",
}: Props) => {
  const [poster, setPoster] = useState(defautlImage);

  return (
    <div>
      {poster ? (
        <div
          className={cn(
            "w-[200px] my-4 h-[200px] rounded-lg overflow-hidden relative",
            className
          )}
        >
          <Suspense fallback={<Skeleton className="w-full h-full" />}>
            <>
              <Button
                type={"button"}
                onClick={(e) => {
                  e.preventDefault();
                  setPoster("");
                }}
                variant={"outline"}
                size={"icon"}
                className="hover:text-red-500 absolute top-0 right-0"
              >
                <MdOutlineCancel />
              </Button>
              <Image
                src={poster}
                alt="some name"
                width={500}
                height={500}
                className="object-cover w-full h-full"
              />
            </>
          </Suspense>
        </div>
      ) : (
        <div className={cn("sm:w-1/2", className)}>
          <Label>رفع {title}</Label>
          <UploadDropzone
            endpoint="imageUploader"
            className=" text-white ut-button:bg-blue-500 ut-button:ut-readying:bg-blue-500/50 ut-button:ut-uploading:bg-blue-500/50 "
            appearance={{
              label: "text-black custom-class hover:text-primary",
              button({ uploadProgress, isUploading }) {
                if (uploadProgress || isUploading) {
                  return "ut-button:ut-uploading:bg-blue-500/50 text-white  custom-button-uploading";
                }
                return "text-white";
              },
            }}
            content={{
              label: `${title}`,
              button({ uploadProgress, isDragActive, ready }) {
                if (!ready) return "جاري الإنتظار...";
                if (uploadProgress)
                  return (
                    <div className=" absolute z-50">
                      جار الرفع {uploadProgress}
                    </div>
                  );
                return isDragActive ? "نسخ" : "رفع ملف";
              },

              allowedContent: "يجب أن لا يتجاوز حجم الصورة 128 ميجابايت",
            }}
            config={{
              appendOnPaste: true,
              mode: "auto",
            }}
            onClientUploadComplete={(res) => {
              console.log(res);
              setPoster(res[0].url);
              toast({ title: "تم الرفع بنجاح" });
            }}
            onUploadError={(error: Error) => {
              alert(`ERROR! ${error.message}`);
            }}
          />
        </div>
      )}
      <Input type={"hidden"} name={name} value={poster} />
    </div>
  );
};

export const ControlledImageDropzone = ({
  title,
  name,
  className,
  poster,
  setPoster,
}: Props & {
  setPoster: Dispatch<SetStateAction<string>>;
  poster: string;
}) => {
  // const [poster, setPoster] = useState(defautlImage);

  return (
    <div>
      {poster ? (
        <div
          className={cn(
            "w-[200px] my-4 h-[200px] rounded-lg overflow-hidden relative",
            className
          )}
        >
          <Suspense fallback={<Skeleton className="w-full h-full" />}>
            <>
              <Button
                type={"button"}
                onClick={(e) => {
                  e.preventDefault();
                  setPoster("");
                }}
                variant={"outline"}
                size={"icon"}
                className="hover:text-red-500 absolute top-0 right-0"
              >
                <MdOutlineCancel />
              </Button>
              <Image
                src={poster}
                alt="some name"
                width={500}
                height={500}
                className="object-cover w-full h-full"
              />
            </>
          </Suspense>
        </div>
      ) : (
        <div className={cn("sm:w-1/2", className)}>
          <Label>رفع {title}</Label>
          <UploadDropzone
            endpoint="imageUploader"
            className=" text-white ut-button:bg-blue-500 ut-button:ut-readying:bg-blue-500/50 ut-button:ut-uploading:bg-blue-500/50 "
            appearance={{
              label: "text-black custom-class hover:text-primary",
              button({ uploadProgress, isUploading }) {
                if (uploadProgress || isUploading) {
                  return "ut-button:ut-uploading:bg-blue-500/50 text-white  custom-button-uploading";
                }
                return "text-white";
              },
            }}
            content={{
              label: `${title}`,
              button({ uploadProgress, isDragActive, ready }) {
                if (!ready) return "جاري الإنتظار...";
                if (uploadProgress)
                  return (
                    <div className=" absolute z-50">
                      جار الرفع {uploadProgress}
                    </div>
                  );
                return isDragActive ? "نسخ" : "رفع ملف";
              },

              allowedContent: "يجب أن لا يتجاوز حجم الصورة 128 ميجابايت",
            }}
            config={{
              appendOnPaste: true,
              mode: "auto",
            }}
            onClientUploadComplete={(res) => {
              console.log(res);
              setPoster(res[0].url);
              toast({ title: "تم الرفع بنجاح" });
            }}
            onUploadError={(error: Error) => {
              alert(`ERROR! ${error.message}`);
            }}
          />
        </div>
      )}
      <Input type={"hidden"} name={name} value={poster} />
    </div>
  );
};

export { ImageDropzone };
