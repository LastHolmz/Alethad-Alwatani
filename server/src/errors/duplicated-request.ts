import CustomAPIError from "./custom-api";
/**
 422 for duplicated record 
*/
class DuplicatedError extends CustomAPIError {
  statusCode: number;
  constructor(message: string) {
    super(message);
    this.statusCode = 422;
  }
}

export default DuplicatedError;
