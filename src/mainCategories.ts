export type MainCategory = {
  id: string;
  name: string;
  description: string;
};

export const MAIN_CATEGORIES: MainCategory[] = [
  { id: "plywood", name: "Plywood", description: "Plywood, boards, doors, flexible plywood and NFC boards." },
  { id: "hardware", name: "Hardware", description: "Hardware fittings and accessories." },
  { id: "glass", name: "Glass", description: "Glass products and solutions." },
  { id: "laminates", name: "Laminates", description: "Decorative laminate products." },
  { id: "modular-kitchen", name: "Modular Kitchen", description: "Modular kitchen products and fittings." },
];

export const PLYWOOD_SUBCATEGORIES = [
  "Plywood",
  "Block Board",
  "MDP / Boards",
  "Doors",
  "Flexible Plywood",
  "NFC Boards",
];

export const HARDWARE_SUBCATEGORIES = [
  "Hinges",
  "Tower Bolts",
  "Aldrops",
  "Latches",
  "Handles",
  "Coat Hooks",
  "Goat Hooks",
  "Baby Latches",
  "Door Stoppers",
  "Deluxe Window Stays",
  "Wardrobe Handles & Knobs",
  "Box Hinges",
  "Telescope Channels",
  "Telescopic Channel",
];
