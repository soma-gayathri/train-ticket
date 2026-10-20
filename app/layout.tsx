import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Railway — Find your next journey",
  description: "Explore sample Indian train schedules and station stops.",
  icons: {
    icon: "/favicon.svg",
    shortcut: "/favicon.svg",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <head><link rel="stylesheet" href="/styles.css" /></head>
      <body>{children}</body>
    </html>
  );
}
