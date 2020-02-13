structure SockSound = 
struct

  (* Generate a loopback socket address *)
  val addr = 
    let val ad = valOf (NetHostDB.fromString "127.0.0.1")
    in  INetSock.toAddr (ad, 65530) (* INetSock.any 65531 *)
    end

  (* Open and connect to the socket *)
  fun init () : (Socket.active INetSock.stream_sock) option = 
    let
      val socket = INetSock.TCP.socket ()
      val _ = Socket.connect (socket, addr)
    in
      SOME socket
    end
    handle SysErr => NONE
    (* handle SysErr e => let val _ = print "Could not connect to sound socket.\n" 
                       in  raise SysErr e
                       end *)

  (* Close the socket connection *)
  fun close (sock) = 
    Socket.close(sock)

  (* Write a string buffer to the socket *)
  fun write (socket, s:string) = 
    (Socket.sendVec (socket, Word8VectorSlice.full (Byte.stringToBytes s)); ())

  (* Play a given note for a given duration to the specified socket *)
  fun play (socket, name, duration) = 
    let val payload = name ^ "," ^ (Real.toString duration) ^ ",1"
        val timeMillis = Int.toLarge (500 + 2000 * (trunc duration))
    in  write (socket, payload);
        OS.Process.sleep (Time.fromMilliseconds timeMillis)
    end

end