import { Response } from "express";

class ResponseHelper {
  static error(arg0: string, arg1: number) {
    throw new Error("Method not implemented.");
  }
  private res: Response;

  constructor(res: Response) {
    this.res = res;
  }

  public success(data: any, message?: string, status?: number): void {
    const response = {
      success: true,
      data,
      status: status,
      message: message || "Success",
    };
    this.res.status(200).json(response);
  }

  public error(message: string, statusCode = 500): void {
    const response = {
      success: false,
      message,
    };
    this.res.status(statusCode).json(response);
  }
}

export default ResponseHelper;
