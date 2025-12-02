import React from "react";
import { Image } from "antd";

export const getColumns = () => [
  {
    title: "Title",
    dataIndex: "title",
    key: "title",
    width: 500,
  },
  {
    title: "Start Date",
    dataIndex: "startdate",
    key: "startdate",
    width: 200,
    render: (value) =>
      value ? new Date(value).toLocaleDateString(undefined, {
        year: "numeric",
        month: "long",
        day: "numeric",
      }) : "",
  },
  {
    title: "image",
    dataIndex: "image",
    key: "image",
    render: (src) =>
      src ? (
        <Image
          src={src}
          alt="Event"
          width={120}
          height={80}
          style={{ objectFit: "cover" }}
        />
      ) : null,
  },
  {
    title: "description",
    dataIndex: "description",
    key: "description",
    render: (text) =>
      text && text.length > 100 ? `${text.slice(0, 100)}...` : text,
  },
];