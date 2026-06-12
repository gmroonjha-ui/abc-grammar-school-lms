import React from 'react';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'ABC Grammar School LMS',
  description: 'Learning Management & ERP System for ABC Grammar School',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>
        <div id="root">{children}</div>
      </body>
    </html>
  );
}
