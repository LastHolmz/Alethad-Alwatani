// Assuming you have a MongoDB document with a dateTime field
interface MyDocument {
  dateTime?: Date | null;
  unknownMsg?: string;
}

// Example function to parse the dateTime field
export function parseDateTime(doc: MyDocument): string {
  const unknown = doc.unknownMsg ?? "غير معروف";
  console.log(doc.dateTime);
  // console.log(doc.dateTime);
  if (!(doc.dateTime instanceof Date)) {
    return unknown;
  }
  if (doc.dateTime === undefined || doc.dateTime === null) {
    return unknown;
  }
  const options: Intl.DateTimeFormatOptions = {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    // hour: "2-digit",
    // minute: "2-digit",
    // second: "2-digit",
    hour12: true,
    timeZone: "UTC",
  };

  const formatter = new Intl.DateTimeFormat("en-GB", options);
  const formattedDateTime = formatter.format(new Date(doc.dateTime));

  // Replace 'AM' with 'ص' and 'PM' with 'م'
  return formattedDateTime
    .replace(/AM/, "ص")
    .replace(/PM/, "م")
    .split("/")
    .reverse()
    .join("-");
}

// const formattedDateTime = parseDateTime(myDocument);
// console.log(formattedDateTime); // Output: '29/07/2023 ص'
