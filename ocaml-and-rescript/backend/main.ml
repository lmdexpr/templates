let log_level = Some Logs.Info

let () =
  Logs.set_reporter (Logs_fmt.reporter ());
  Logs.set_level log_level;
  Logs_threaded.enable ();
  Logs.Src.set_level Cohttp_eio.src log_level

let () = Mirage_crypto_rng_unix.use_default ()

let () =
  Eio_main.run @@ fun env ->
  let open Cohttp_eio in
  let callback _socket request _body =
    match Http.Request.(meth request, resource request) with
    | `GET, "/api/hello" -> Server.respond_string ~status:`OK ~body:"hello" ()
    | _ -> Server.respond_string ~status:`Not_found ~body:"" ()
  in
  let on_error ex = Logs.warn @@ fun f -> f "%a" Eio.Exn.pp ex in

  let port = 8080 in

  Eio.Switch.run @@ fun sw ->
  let socket =
    Eio.Net.listen env#net ~sw ~backlog:128 ~reuse_addr:true (`Tcp (Eio.Net.Ipaddr.V4.any, port))
  in
  Logs.info (fun f -> f "Listening on port %d" port);
  Server.run socket ~on_error @@ Server.make ~callback ()
