export function formatDate(date: Date, style: "short" | "long" = "short") {
  return date.toLocaleDateString("fr-FR", {
    day: "numeric",
    month: style === "short" ? "short" : "long",
    year: "numeric",
  });
}
