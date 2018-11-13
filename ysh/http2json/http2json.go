package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"
)

type cookieMap map[string]*http.Cookie

type out struct {
	Status     string
	StatusCode int
	Proto      string
	ProtoMajor int
	ProtoMinor int
	Header     http.Header
	Body       string
	Cookies    cookieMap
}

func main() {

	// read stdin
	scanner := bufio.NewScanner(os.Stdin)
	s := ""
	for scanner.Scan() {
		l := scanner.Text()
		// skip transfer-encoding header as the body is already decoded from httpie
		if strings.HasPrefix(strings.ToLower(l), "transfer-encoding:") {
			continue
		}
		if strings.HasPrefix(strings.ToLower(l), "content-length:") {
			continue
		}
		if strings.HasPrefix(strings.ToLower(l), "content-encoding:") {
			continue
		}
		s = s + l + "\n"
	}
	reader := bufio.NewReader(strings.NewReader(strings.TrimSuffix(s, "\n")))

	// parse as an http response
	res, err := http.ReadResponse(reader, nil)
	if err != nil {
		log.Fatal(err)
	}

	// read the body
	var bod string
	bodyBytes, err := ioutil.ReadAll(res.Body)
	if err != nil {
		fmt.Println("ERR", err)
		bod = ""
	} else {
		bod = string(bodyBytes)
		res.Body.Close()
	}

	o := out{
		res.Status,
		res.StatusCode,
		res.Proto,
		res.ProtoMajor,
		res.ProtoMinor,
		res.Header,
		bod,
		make(cookieMap),
	}
	for _, c := range res.Cookies() {
		o.Cookies[c.Name] = c
	}
	j, _ := json.Marshal(o)
	fmt.Print(string(j))

}
