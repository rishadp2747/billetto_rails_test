import React from "react";
import { Image, Button, Space } from "antd";

export const getColumns = (onLike, onDislike) => [
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
    dataIndex: "image_link",
    key: "image_link",
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
  {
    title: "Likes",
    dataIndex: ["event_vote_count", "likes"],
    key: "likes",
    width: 100,
    render: (value) => value ?? 0,
  },
  {
    title: "Dislikes",
    dataIndex: ["event_vote_count", "dislikes"],
    key: "dislikes",
    width: 100,
    render: (value) => value ?? 0,
  },
  {
    title: "Actions",
    key: "actions",
    width: 150,
    render: (_, record) => (
      <Space>
        <Button
          label="Like"
          onClick={() => onLike(record)}
        >Like</Button>
        <Button
          label="Dislike"
          onClick={() => onDislike(record)}
        >DisLike</Button>
      </Space>
    ),
  },
];