import { getColumns } from "./columns";
import { Table } from "antd";
import React, { useState } from "react";
import { useEventsApi ,useEventsVoteApi} from "../../hooks/useEventsApi";

const Events = () => {
  const [page, setPage] = useState(1);

  const { data = {}, isLoading, isError, error } = useEventsApi(page);
  const {mutate: createEventVote}= useEventsVoteApi()

  const onLike = (record) =>{
    createEventVote({event_vote: {event_id: record.id, vote_kind: "like" }})
  }

  const onDislike = (record)=>{
    createEventVote({event_vote:{event_id: record.id, vote_kind: "dislike" }})
  }

  if (isError) {
    return <div>Error loading events: {error?.message}</div>;
  }

  return (
    <Table
      columns={getColumns(onLike,onDislike)}
      dataSource={data?.events}
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