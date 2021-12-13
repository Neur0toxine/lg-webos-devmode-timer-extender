package main

import (
	"log"
	"os"
	"strings"

	"github.com/Neur0toxine/lg-webos-devmode-timer-extender/api"
)

const TokenParam = "--token="

func main() {
	token := getTokenArg()
	if token == "" {
		log.Println("Usage:")
		log.Printf("$ %s %stoken\n", os.Args[0], TokenParam)
		os.Exit(1)
	}

	client := api.New(token)
	timeLeft, err := client.Query()
	if err != nil {
		log.Fatalln("Cannot query devmode status:", err)
	}

	log.Println("Time left before resetting:", timeLeft)

	if err := client.Extend(); err != nil {
		log.Fatalln("Cannot extend devmode timer:", err)
	}

	timeLeft, err = client.Query()
	if err != nil {
		log.Fatalln("Cannot query devmode status again:", err)
	}

	log.Println("Time left after resetting:", timeLeft)
}

func getTokenArg() string {
	if len(os.Args) != 2 {
		return ""
	}

	if !strings.HasPrefix(os.Args[1], TokenParam) {
		return ""
	}

	return strings.TrimSpace(os.Args[1][len(TokenParam):])
}
