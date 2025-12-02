import { getColumns } from "./columns";
import { useQuery } from "@tanstack/react-query";
import { Table } from "antd";
import React, { useState } from "react";
import { fetchEvents } from "./utils";

const Events = () => {
  const [page, setPage] = useState(1);

  const { data, isLoading, isError, error } = useQuery({
    queryKey: ["events", page],
    queryFn: () => fetchEvents(page),
    keepPreviousData: true,
  });

  if (isError) {
    return <div>Error loading events: {error.message}</div>;
  }

  const events =
    data?.events?.map((event) => ({
      ...event,
      date: event.startdate,
      image: event.image_link,
    })) || [];

  return (
    <Table
      columns={getColumns()}
      dataSource={events}
      rowKey="id"
      loading={isLoading}
      pagination={{
        current: data?.pagination?.current_page || page,
        total: data?.pagination?.count || 0,
        pageSize: 20,
      }}
      onChange={(pagination) => {
        if (pagination.current && pagination.current !== page) {
          setPage(pagination.current);
        }
      }}
    />
  );
};

export default Events;