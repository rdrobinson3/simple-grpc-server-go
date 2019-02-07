package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"os"

	"github.com/rdrobinson3/simple-grpc-server-go/api"
	"golang.org/x/net/context"
	"google.golang.org/grpc"
)

const PROMPT = ">> "

func main() {
	var conn *grpc.ClientConn
	conn, err := grpc.Dial(":7777", grpc.WithInsecure())
	if err != nil {
		log.Fatalf("did not connect: %s", err)
	}

	replMode := flag.Bool("repl", false, "repl mode enabled")
	flag.Parse()

	// defer conn.Close()

	c := api.NewPingClient(conn)

	if *replMode {
		scanner := bufio.NewScanner(os.Stdin)

		for {
			fmt.Printf(PROMPT)
			scanned := scanner.Scan()
			if !scanned {
				return
			}

			line := scanner.Text()
			sendMessage(c, line)
		}
	} else {
		sendMessage(c, "hello")
	}
}

func sendMessage(c api.PingClient, message string) {
	response, err := c.SayHello(context.Background(), &api.PingMessage{Greeting: message})
	if err != nil {
		log.Fatalf("Error when calling SayHello: %s", err)
	}
	log.Printf("Response from server: %s", response.Greeting)
}
