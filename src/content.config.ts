import { defineCollection, z } from "astro:content";
import { glob } from "astro/loaders";

const projets = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/projets" }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    tags: z.array(z.string()).default([]),
    repoUrl: z.string().url().optional(),
    order: z.number().default(0),
  }),
});

const writeups = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/writeups" }),
  schema: z.object({
    title: z.string(),
    date: z.coerce.date(),
    summary: z.string(),
    tags: z.array(z.string()).default([]),
    project: z.string().optional(),
    externalUrl: z.string().url().optional(),
    draft: z.boolean().default(false),
  }),
});

export const collections = { projets, writeups };