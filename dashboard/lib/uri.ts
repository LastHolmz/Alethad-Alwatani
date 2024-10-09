const renderUriRepos = "https://alethad-alwatani.onrender.com";
const renderUriLastHermis = "https://alethad-alwatani-qn7u.onrender.com";

const uri =
  process.env.NODE_ENV === "production"
    ? `${renderUriRepos}/api/v1`
    : "http://localhost:10000/api/v1";
export default uri;
