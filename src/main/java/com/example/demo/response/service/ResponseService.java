package com.example.demo.response.service;

import com.example.demo.response.code.SuccessCode;
import com.example.demo.response.dto.Data;
import com.example.demo.response.dto.ResponseDto;
import org.springframework.http.ResponseEntity;

public interface ResponseService {
    public ResponseEntity<ResponseDto> successResult(SuccessCode code);
    public ResponseEntity<ResponseDto> successResult(SuccessCode code, Data body);
}