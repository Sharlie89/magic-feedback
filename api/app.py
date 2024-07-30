from flask import Flask, request, jsonify

app = Flask(__name__)

# Endpoint for receiving feedback
@app.route('/feedback', methods=['POST'])
def receive_feedback():
    data = request.get_json()
    # Process the feedback data here
    return jsonify({"message": "Feedback received", "data": data}), 200

# Health check endpoint
@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "healthy"}), 200

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
