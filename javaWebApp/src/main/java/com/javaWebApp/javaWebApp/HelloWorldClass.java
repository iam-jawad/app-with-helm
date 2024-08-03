package com.javaWebApp.javaWebApp;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldClass {

    @GetMapping("/")
    public String sayHello() {
        return "Hi, This is Jawad's DevOps Assessment.";
    }
}
