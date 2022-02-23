class Payment {
  final String? executeUrl;
  final String? approvalUrl;
  final bool status;

  Payment({
    this.executeUrl,
    this.approvalUrl,
    required this.status,
  });
}
