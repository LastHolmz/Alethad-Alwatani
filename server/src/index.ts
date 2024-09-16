import "dotenv/config";
import express, { Request, Response, NextFunction, json } from "express";
import helmet from "helmet";
import compression from "compression";
import cors from "cors";
import prisma from "../prisma/db";
import notFound from "./middlewares/not-found";
import errorHandlerMiddleware from "./middlewares/error-handler";
import {
  authRouters,
  productsRouters,
  skusRouters,
  categoriesRouters,
  brandsRouters,
} from "./routes";
// import bodyParser from 'body-parser';

const app = express();

// app.use(helmet());

app.use(json()); // application/json
// // app.use(bodyParser.json());
// app.use(express.urlencoded({ extended: true }));

// app.use(compression());
// app.use(cors());

app.get("/", async (req, res) => {
  try {
    await prisma.user.deleteMany();
    res.json({ message: "done" });
  } catch (error) {
    console.log(error);
    res.json(error);
  }
});

// app.options("*", cors());

// app.use(limiter);

app.use("/api/v1/auth", authRouters);
app.use("/api/v1/products", productsRouters);
app.use("/api/v1/skus", skusRouters);
app.use("/api/v1/categories", categoriesRouters);
app.use("/api/v1/brands", brandsRouters);
// app.use("/api/v1", isAuth, authorise(false, "user"), adminRoutes);
app.use(notFound);
app.use(errorHandlerMiddleware);
const PORT = process.env.PORT || 8080;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}.`);
});

app.use((err: any, req: Request, res: Response, next: NextFunction) => {
  const status = err.status || 500;
  const message = err.message;
  res.status(status).json({ error: message });
});
