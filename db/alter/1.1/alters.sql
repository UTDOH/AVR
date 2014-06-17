CREATE INDEX idx_address_updated_at ON warehouse.dim_address ( src_updated_at );

ALTER TABLE warehouse.dim_address RENAME COLUMN updated_at TO src_updated_at;

ALTER TABLE warehouse.dim_address RENAME COLUMN created_at TO src_created_at;

CREATE INDEX idx_person_updated_at ON warehouse.dim_person ( src_updated_at );

COMMENT ON COLUMN warehouse.dim_person.src_updated_at IS 'Source updated timestamp from trisano';

ALTER TABLE warehouse.dim_person ADD src_updated_at timestamp ;

COMMENT ON COLUMN warehouse.dim_person.src_created_at IS 'Source created_at timestamp from trisano';

ALTER TABLE warehouse.dim_person ADD src_created_at timestamp;

CREATE INDEX idx_updated_at ON warehouse.dim_location ( updated_at );

CREATE INDEX idx_src_updated_at ON warehouse.dim_outbreak ( src_updated_at );

ALTER TABLE warehouse.dim_jurisdiction RENAME COLUMN src_modified_at TO src_updated_at;

ALTER TABLE warehouse.dim_outbreak RENAME COLUMN src_modified_at TO src_updated_at;

ALTER TABLE warehouse.dim_outbreak RENAME COLUMN modified_at TO src_modified_at;

ALTER TABLE warehouse.dim_outbreak RENAME COLUMN created_at TO src_created_at;

COMMENT ON COLUMN warehouse.dim_outbreak.modified_at IS 'Source modfied_at from trisano.';

ALTER TABLE warehouse.dim_outbreak ADD modified_at timestamp;

COMMENT ON COLUMN warehouse.dim_outbreak.created_at IS 'Source created_at timestamp from trisano.';

ALTER TABLE warehouse.dim_outbreak ADD created_at timestamp;






