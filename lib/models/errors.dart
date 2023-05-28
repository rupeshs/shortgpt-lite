enum AppErrorType {
  // Something happened in setting up or sending the request that triggered an Error
  requestSetupSend,
  // Errors in range 500
  serverError,
  // Request processing error
  requestError,
  // Empty API key
  emptyApiKey,
  // Empty API key
  emptyPrompt,
  // Authentication Error
  authError
}

class AppError {
  AppErrorType appErrorType;
  String message;
  String longMessage;
  AppError(this.appErrorType, this.message, this.longMessage);
}
