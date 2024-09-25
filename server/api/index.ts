// import "dotenv/config";
// import express, { Request, Response, NextFunction, json } from "express";
// import helmet from "helmet";
// import compression from "compression";
// import cors from "cors";
// import prisma from "../prisma/db";
// import notFound from "./middlewares/not-found";
// import errorHandlerMiddleware from "./middlewares/error-handler";
// import {
//   authRouters,
//   productsRouters,
//   skusRouters,
//   categoriesRouters,
//   brandsRouters,
//   ordersRouters,
//   usersRouters,
// } from "./routes";
// import { authenticate, authorize } from "./middlewares/auth";
// // import bodyParser from 'body-parser';

// const app = express();

// app.use(helmet());

// // Define allowed origins (only the web dashboard)
// const allowedOrigins = [
//   "https://alethad-alwatani.vercel.app/",
//   "http://localhost:3000", // For local development of the dashboard
// ];

// // CORS configuration for the web dashboard
// const corsOptions: cors.CorsOptions = {
//   origin: (origin, callback) => {
//     // Allow requests from allowed origins, skip CORS for non-browser clients
//     if (!origin || allowedOrigins.includes(origin)) {
//       callback(null, true);
//     } else {
//       callback(new Error("Not allowed by CORS"));
//     }
//   },
//   credentials: true, // Enable credentials if needed
// };

// app.use(cors(corsOptions));

// app.use(json());
// // app.use(express.urlencoded({ extended: true }));

// app.use(compression());

// app.get("/", async (req, res) => {
//   try {
//     // await prisma.user.deleteMany();
//     res.json({ message: "welcome 😊" });
//   } catch (error) {
//     console.log(error);
//     res.json(error);
//   }
// });

// // app.options("*", cors());

// // app.use(limiter);

// app.use("/api/v1/auth", authRouters);
// // app.use(authenticate);
// app.use("/api/v1/products", productsRouters);
// app.use("/api/v1/skus", skusRouters);
// app.use("/api/v1/categories", categoriesRouters);
// app.use("/api/v1/brands", brandsRouters);
// app.use("/api/v1/orders", authenticate, ordersRouters);
// app.use(
//   "/api/v1/users",
//   authenticate,
//   authorize(["admin"], ["active"]),
//   usersRouters
// );
// app.use(notFound);
// app.use(errorHandlerMiddleware);
// const PORT = process.env.PORT || 8080;

// app.listen(PORT, () => {
//   console.log(`Server is running on port ${PORT}.`);
// });

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
  ordersRouters,
  usersRouters,
} from "./routes";
import { authenticate, authorize } from "./middlewares/auth";

const app = express();

app.use(helmet());

// Define allowed origins (only the web dashboard)
const allowedOrigins = [
  "https://alethad-alwatani.vercel.app", // Without trailing slash
  "https://alethad-alwatani.vercel.app/", // With trailing slash
  "http://localhost:3000", // For local development of the dashboard
];

// CORS configuration for the web dashboard
const corsOptions: cors.CorsOptions = {
  origin: (origin, callback) => {
    // Allow requests from allowed origins, skip CORS for non-browser clients
    if (
      !origin ||
      allowedOrigins.some((allowed) => origin.startsWith(allowed))
    ) {
      callback(null, true);
    } else {
      callback(new Error("Not allowed by CORS"));
    }
  },
  credentials: true, // Enable credentials if needed
};

app.use(cors(corsOptions));

app.use(json());

app.use(compression());

app.get("/", async (req, res) => {
  try {
    res.json({ message: "welcome 😊" });
  } catch (error) {
    console.log(error);
    res.json(error);
  }
});

app.use("/api/v1/auth", authRouters);
app.use("/api/v1/products", productsRouters);
app.use("/api/v1/skus", skusRouters);
app.use("/api/v1/categories", categoriesRouters);
app.use("/api/v1/brands", brandsRouters);
app.use("/api/v1/orders", authenticate, ordersRouters);
app.use(
  "/api/v1/users",
  authenticate,
  authorize(["admin"], ["active"]),
  usersRouters
);
app.use(notFound);
app.use(errorHandlerMiddleware);

const PORT = process.env.PORT || 8080;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}.`);
});
