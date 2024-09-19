import { JwtUser } from "../../types";
import jwt from "jsonwebtoken";
const generateJwtToken = (user: JwtUser) => {
  const token: string = jwt.sign(
    { user },
    process.env.JWT_PRIVATE_KEY as string,
    { expiresIn: "30d" }
  );

  return token;
};

const decodedJwtToken = (token: string) => {
  const response = jwt.verify(token, process.env.JWT_PRIVATE_KEY as string) as {
    user: JwtUser;
  };
  if (!response || response === null || response === undefined) {
    return undefined;
  }
  return response;
};

export { generateJwtToken, decodedJwtToken };
