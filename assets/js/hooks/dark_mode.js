const DarkMode = {
  mounted() {
    this.darkMode = document.documentElement.classList.contains("dark");
    this.updateIcons();

    this.el.addEventListener("click", () => {
      this.darkMode = !this.darkMode;
      this.updateDarkMode();
    });
  },

  updateDarkMode() {
    document.documentElement.classList.toggle("dark", this.darkMode);
    localStorage.setItem("darkMode", this.darkMode);
    this.updateIcons();
  },

  updateIcons() {
    const sunIcon = this.el.querySelector(".dark-mode-sun");
    const moonIcon = this.el.querySelector(".dark-mode-moon");

    if (this.darkMode) {
      sunIcon.style.display = "block";
      moonIcon.style.display = "none";
    } else {
      sunIcon.style.display = "none";
      moonIcon.style.display = "block";
    }
  },
};

export default DarkMode;
