-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- CreateEnum
CREATE TYPE "severity_level_enum" AS ENUM ('low', 'medium', 'high');

-- CreateTable
CREATE TABLE "tokens" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "name" VARCHAR(255) NOT NULL,
    "symbol" VARCHAR(50) NOT NULL,
    "address" VARCHAR(255) NOT NULL,
    "chain_id" VARCHAR(50),

    CONSTRAINT "tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "agent_results" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "token_id" UUID NOT NULL,
    "section" VARCHAR(50) NOT NULL,
    "summary" TEXT NOT NULL,
    "score" DOUBLE PRECISION,
    "data_updated_at" TIMESTAMPTZ(6),

    CONSTRAINT "agent_results_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "red_flags" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "agent_result_id" UUID NOT NULL,
    "category" VARCHAR(100) NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "description" TEXT NOT NULL,
    "severity" "severity_level_enum" NOT NULL,
    "evidence" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "detected_at" TIMESTAMPTZ(6),
    "source" VARCHAR(100),
    "recommended_action" TEXT,

    CONSTRAINT "red_flags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reports" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "token_id" UUID NOT NULL,
    "summary" TEXT,
    "created_at" TIMESTAMPTZ(6),
    "version" VARCHAR(20),
    "tokenomics_section" TEXT,
    "tokenomics_summary" TEXT,
    "tokenomics_score" DOUBLE PRECISION,
    "sentiment_section" TEXT,
    "sentiment_summary" TEXT,
    "sentiment_score" DOUBLE PRECISION,
    "onchain_section" TEXT,
    "onchain_summary" TEXT,
    "onchain_score" DOUBLE PRECISION,
    "team_section" TEXT,
    "team_summary" TEXT,
    "team_score" DOUBLE PRECISION,
    "code_section" TEXT,
    "code_summary" TEXT,
    "code_score" DOUBLE PRECISION,
    "whitepaper_section" TEXT,
    "whitepaper_summary" TEXT,
    "whitepaper_score" DOUBLE PRECISION,
    "audit_section" TEXT,
    "audit_summary" TEXT,
    "audit_score" DOUBLE PRECISION,

    CONSTRAINT "reports_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "tokens_address_key" ON "tokens"("address");

-- CreateIndex
CREATE INDEX "idx_tokens_symbol" ON "tokens"("symbol");

-- CreateIndex
CREATE INDEX "idx_tokens_address" ON "tokens"("address");

-- CreateIndex
CREATE INDEX "idx_agent_results_token_id" ON "agent_results"("token_id");

-- CreateIndex
CREATE INDEX "idx_agent_results_section" ON "agent_results"("section");

-- CreateIndex
CREATE INDEX "idx_agent_results_data_updated_at" ON "agent_results"("data_updated_at");

-- CreateIndex
CREATE INDEX "idx_red_flags_agent_result_id" ON "red_flags"("agent_result_id");

-- CreateIndex
CREATE INDEX "idx_red_flags_category" ON "red_flags"("category");

-- CreateIndex
CREATE INDEX "idx_red_flags_severity" ON "red_flags"("severity");

-- CreateIndex
CREATE INDEX "idx_red_flags_detected_at" ON "red_flags"("detected_at");

-- CreateIndex
CREATE INDEX "idx_reports_token_id" ON "reports"("token_id");

-- CreateIndex
CREATE INDEX "idx_reports_created_at" ON "reports"("created_at");

-- AddForeignKey
ALTER TABLE "agent_results" ADD CONSTRAINT "agent_results_token_id_fkey" FOREIGN KEY ("token_id") REFERENCES "tokens"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "red_flags" ADD CONSTRAINT "red_flags_agent_result_id_fkey" FOREIGN KEY ("agent_result_id") REFERENCES "agent_results"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reports" ADD CONSTRAINT "reports_token_id_fkey" FOREIGN KEY ("token_id") REFERENCES "tokens"("id") ON DELETE CASCADE ON UPDATE CASCADE;
