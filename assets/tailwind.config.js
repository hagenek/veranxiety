// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin");
const fs = require("fs");
const path = require("path");

module.exports = {
  darkMode: "class",
  content: [
    "./js/**/*.js",
    "../lib/veranxiety_web.ex",
    "../lib/veranxiety_web/**/*.*ex",
  ],
  theme: {
    extend: {
      colors: {
        // Base colors
        base: {
          DEFAULT: "var(--bg-primary)",
          dark: "var(--base)",
        },
        surface: {
          DEFAULT: "var(--bg-secondary)",
          dark: "var(--surface0)",
        },
        text: {
          DEFAULT: "var(--text-primary)",
          dark: "var(--text)",
          secondary: "var(--text-secondary)",
        },

        // Catppuccin colors
        rosewater: "var(--rosewater)",
        flamingo: "var(--flamingo)",
        pink: "var(--pink)",
        mauve: "var(--mauve)",
        red: "var(--red)",
        maroon: "var(--maroon)",
        peach: "var(--peach)",
        yellow: "var(--yellow)",
        green: "var(--green)",
        teal: "var(--teal)",
        sky: "var(--sky)",
        sapphire: "var(--sapphire)",
        blue: "var(--blue)",
        lavender: "var(--lavender)",

        // Additional Catppuccin shades
        subtext: {
          1: "var(--subtext1)",
          0: "var(--subtext0)",
        },
        overlay: {
          2: "var(--overlay2)",
          1: "var(--overlay1)",
          0: "var(--overlay0)",
        },
        surface: {
          2: "var(--surface2)",
          1: "var(--surface1)",
          0: "var(--surface0)",
        },
        mantle: "var(--mantle)",
        crust: "var(--crust)",

        // Your custom color mappings
        muted: "var(--overlay1)",
        subtle: "var(--overlay0)",
        love: "var(--red)",
        gold: "var(--yellow)",
        rose: "var(--pink)",
        pine: "var(--green)",
        foam: "var(--sky)",
        iris: "var(--mauve)",
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [
        ".phx-click-loading&",
        ".phx-click-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [
        ".phx-submit-loading&",
        ".phx-submit-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [
        ".phx-change-loading&",
        ".phx-change-loading &",
      ])
    ),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function ({ matchComponents, theme }) {
      let iconsDir = path.join(__dirname, "../deps/heroicons/optimized");
      let values = {};
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
        ["-micro", "/16/solid"],
      ];
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach((file) => {
          let name = path.basename(file, ".svg") + suffix;
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) };
        });
      });
      matchComponents(
        {
          hero: ({ name, fullPath }) => {
            let content = fs
              .readFileSync(fullPath)
              .toString()
              .replace(/\r?\n|\r/g, "");
            let size = theme("spacing.6");
            if (name.endsWith("-mini")) {
              size = theme("spacing.5");
            } else if (name.endsWith("-micro")) {
              size = theme("spacing.4");
            }
            return {
              [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
              "-webkit-mask": `var(--hero-${name})`,
              mask: `var(--hero-${name})`,
              "mask-repeat": "no-repeat",
              "background-color": "currentColor",
              "vertical-align": "middle",
              display: "inline-block",
              width: size,
              height: size,
            };
          },
        },
        { values }
      );
    }),
  ],
};
