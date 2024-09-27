const uri =
  process.env.NODE_ENV === "production"
    ? "https://alethad-alwatani-qn7u.onrender.com/api/v1"
    : "http://localhost:10000/api/v1";

export default uri;
