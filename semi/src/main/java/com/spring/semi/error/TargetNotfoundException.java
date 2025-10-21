package com.spring.semi.error;

public class TargetNotfoundException extends RuntimeException{
	private static final long seriralVersionUID= 1L;
	public TargetNotfoundException() {
		super();
	}
	public TargetNotfoundException(String message) {
		super(message);
	}

}
