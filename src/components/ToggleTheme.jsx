import { createEffect, createSignal, onMount } from "solid-js";

export default function ToggleTheme() {

    // if any invalid values it will default to white
    const [theme, setTheme] = createSignal("");
    onMount(async () => {
        setTheme((typeof localStorage !== "undefined" && "theme" in localStorage) ? localStorage.theme : window.matchMedia('(prefers-color-scheme: dark)').matches ? "dark" : "light");
    })


    createEffect(() => {
        const rootCL = document.documentElement.classList;
        localStorage.theme = theme();
        theme() === "dark" ? rootCL.add("dark") : rootCL.remove("dark");
    });

    return (
        <>
            <label class="relative cursor-pointer rounded-full">
                <input
                    type="checkbox"
                    class="opacity-0 absolute w-0 h-0"
                    tabindex="0"
                    onchange={() =>
                        setTheme((t) => t !== "light" ? "light" : "dark")
                    }
                />
                <span class="border-current border-4 bg-current text-black rounded-l-full h-2 relative w-16 inline-block " />
                <span class="border-current border-4 bg-current text-white rounded-r-full h-2 relative bg-white w-16 inline-block" />
            </label>
        </>
    );
}
