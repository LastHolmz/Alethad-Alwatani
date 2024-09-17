const uri =
  process.env.NODE_ENV === "production"
    ? "https://alethad-alwatani.onrender.com"
    : "http://localhost:10000/api/v1";

export default uri;
