// class CustomAPIError extends Error {
//   constructor(message: string) {
//     super(message);
//   }
// }

// export default CustomAPIError;

class CustomAPIError extends Error {
  statusCode?: number;

  constructor(message: string, statusCode?: number) {
    super(message);
    this.statusCode = statusCode;
    Object.setPrototypeOf(this, CustomAPIError.prototype); // Ensures proper instance type
  }
}

export default CustomAPIError;
