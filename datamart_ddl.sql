CREATE TABLE IF NOT EXISTS analysis.dm_rfm_segments (
	user_id int4 NOT NULL,
	recency smallint NOT NULL,	
	frequency smallint NOT NULL,
	monetary_value smallint NOT null,
	CONSTRAINT recency_check CHECK (((recency >= 1) AND (recency <= 5))),
	CONSTRAINT frequency_check CHECK (((frequency >= 1) AND (frequency <= 5))),
	CONSTRAINT monetary_value_check CHECK (((monetary_value >= 1) AND (monetary_value <= 5))),
	CONSTRAINT dm_rfm_segments_pkey PRIMARY KEY (user_id)
);