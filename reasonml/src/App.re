/*
 * In ReasonML, a module is similar to a TypeScript or JavaScript module.
 * It's a way to group related functions, types, and components. Here, `App`
 * is a module that encapsulates our main app component.
 *
 * The `[@react.component]` attribute is a special annotation in ReasonML for 
 * React. It's used to define a React component in a way that's more idiomatic 
 * to ReasonML. This attribute automatically manages the props transformation, 
 * providing a seamless integration with React's component model.
 *
 * The `make` function inside the module is equivalent to defining a functional 
 * component in React using JavaScript or TypeScript. In ReasonML, it's common 
 * to name the main function of a component `make` instead of the component's 
 * name.
 */
 module App = {
  [@react.component]
  let make = () => {
    let (show_configuration, setShow_configuration) =
      React.useState(() => false);

    /*
     * The `Cma_configuration.Configuration.make` function is a for creating 
     * the Configuration.t type. It is a common convention in ReasonML to 
     * name a module's corresponding type it operates on or represents, `t`.

     * In ReasonML, named arguments are used extensively, which
     * correspond to passing an object with named properties in JavaScript.
     * Each `~` symbol represents a named argument, similar to an object's key 
     * in JS/TS. The `~name`, `~directory`, `~node_package_manager`, and other 
     * arguments are akin to specifying properties in a JavaScript object. The 
     * placeholders inside the curly braces (e.g., `reasonml`) will be replaced 
     * with actual values, just like template literals or variables in JS/TS.
     *
     * The `()` at the end of the function call represents the `unit` type in 
     * ReasonML, akin to `void` in other languages. It's used here to signify 
     * the end of the function call with named arguments, a syntactic 
     * requirement in ReasonML for functions ending with labelled arguments. 
     * This ensures a clear end of the argument list.
     */
    let configuration =
      Cma_configuration.Configuration.make(
        ~name="reasonml",
        ~directory="/home/lmdexpr/Workspace/templates/reasonml",
        ~node_package_manager=Npm,
        ~bundler=Vite,
        ~is_react_app=true,
        ~initialize_git=false,
        ~initialize_npm=true,
        ~initialize_ocaml_toolchain=false,
        (),
      );

    /*
     * Because ReasonML is has a stronger type system than TypeScript, we have
     * different variants of `useEffect` depending on the number of dependencies
     * we have in our effect.
     *
     * For example, if we have no dependencies, we use `useEffect0`.
     * The equivalent in JavaScript would be `useEffect(() => {}, [])`
     *
     * If we have one dependency, we use `useEffect1`.
     * The equivalent in JavaScript would be `useEffect(() => {}, [dependency])`
     */
    React.useEffect0(() => {
      let timeout_id =
        Js.Global.setTimeout(~f=() => setShow_configuration(_ => true), 1000);

      // Return a cleanup function to cancel the timeout
      // If we didn't need a cleanup function, we would return `None` instead of
      // `Some(() => Js.Global.clearTimeout(timeout_id))`
      Some(() => Js.Global.clearTimeout(timeout_id));
    });

    <>
      <div className="h-[15%]" />
      <div
        className="flex flex-col items-center justify-center rounded-3xl bg-gradient-to-b from-[#24273a] to-[#181926] p-6 shadow outline outline-2 outline-[#f5bde6]">
        <h1
          className="mb-2 pb-1 bg-gradient-to-r from-[#f5bde6] to-[#c6a0f6] bg-clip-text text-7xl font-black text-transparent">
          /*
           * `React.string` in ReasonML is used to convert plain strings into 
           * React text elements. This is necessary because in ReasonML, you 
           * can't directly render strings in JSX. It's similar to how text 
           * content is treated in JSX/TSX in the JavaScript/TypeScript world, 
           * but with explicit conversion for better type safety and clarity in 
           * the ReasonML ecosystem.
           */
          {React.string("create-melange-app")}
        </h1>
        <h2
          className="mb-3 border-b-2 bg-gradient-to-r from-[#ee99a0] to-[#f5a97f] bg-clip-text text-4xl  font-black text-transparent pb-1">
          {React.string("Welcome to Melange & ReasonML!")}
        </h2>
        {show_configuration ? <Components.Configuration configuration /> : React.null}
      </div>
    </>;
  };
};

ReactDOM.querySelector("#root")
->(
    fun
    | Some(root_elem) => {
        let root = ReactDOM.Client.createRoot(root_elem);
        ReactDOM.Client.render(root, <App />);
      }
    | None =>
      Js.Console.error(
        "Failed to start React: couldn't find the #root element",
      )
  );

