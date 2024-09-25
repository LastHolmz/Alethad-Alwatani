import { Request, Response, NextFunction } from "express";
import { StatusCodes } from "http-status-codes";
import { CustomAPIError } from "../errors";

interface ExtendedError extends Error {
  statusCode?: number;
  code?: number;
  errors?: Record<string, any>;
  keyValue?: Record<string, string>;
  value?: string;
}

/**
 * Middleware for handling errors and sending a custom error response.
 *
 * This middleware intercepts errors thrown in the application, determines the type of error,
 * and sends a structured JSON response with an appropriate HTTP status code and message.
 *
 * @param {ExtendedError} err - The error object containing details about the error.
 * @param {Request} req - The Express request object.
 * @param {Response} res - The Express response object.
 * @param {NextFunction} next - The next middleware function in the stack.
 * @returns {Response} The Express response object with the error message and status code.
 */
const errorHandlerMiddleware = (
  err: ExtendedError,
  _: Request,
  res: Response,
  __: NextFunction
): Response => {
  // Define a default error structure
  let customError = {
    statusCode: err.statusCode || StatusCodes.INTERNAL_SERVER_ERROR,
    msg: err.message || "Something went wrong, try again later",
  };

  // Handle specific error types
  if (err instanceof CustomAPIError) {
    customError.statusCode =
      err.statusCode || StatusCodes.INTERNAL_SERVER_ERROR;
    customError.msg = err.message;
  } else if (err.name === "ValidationError") {
    customError.msg = Object.values(err.errors || {})
      .map((item) => item.message)
      .join(",");
    customError.statusCode = 400;
  } else if (err.code && err.code === 11000) {
    customError.msg = `Duplicate value entered for ${Object.keys(
      err.keyValue || {}
    )} field, please choose another value`;
    customError.statusCode = 400;
  } else if (err.name === "CastError") {
    customError.msg = `No item found with id: ${err.value}`;
    customError.statusCode = 404;
  }

  // Send the custom error response
  return res.status(customError.statusCode).json({ msg: customError.msg });
};

export default errorHandlerMiddleware;
