use axum::{
    extract::Json,
    http::{HeaderMap, StatusCode},
    response::IntoResponse,
    routing::post,
    Router,
};
use serde::{Deserialize, Serialize};
use subtle::ConstantTimeEq;
use tower_http::set_header::SetResponseHeaderLayer;

#[derive(Deserialize, Serialize, Debug)]
pub struct TransferRequest {
    pub recipient_id: String,
    pub amount_in_cents: u64, // Zero float rounding
}

// 🛡️ Constant-time authentication check
fn verify_token(headers: &HeaderMap) -> bool {
    let expected = b"super-secret-token-key-2026";
    if let Some(auth) = headers.get("X-Auth-Token") {
        return auth.as_bytes().ct_eq(expected).into();
    }
    false
}

async fn handle_transfer(
    headers: HeaderMap,
    Json(payload): Json<TransferRequest>,
) -> impl IntoResponse {
    if !verify_token(&headers) {
        return (StatusCode::UNAUTHORIZED, "Unauthorized").into_response();
    }

    (
        StatusCode::OK,
        Json(serde_json::json!({
            "status": "success",
            "transferred_cents": payload.amount_in_cents
        })),
    )
        .into_response()
}

#[tokio::main]
async fn main() {
    let app = Router::new()
        .route("/transfer", post(handle_transfer))
        // 🛡️ Security Headers
        .layer(SetResponseHeaderLayer::overriding(
            axum::http::header::X_CONTENT_TYPE_OPTIONS,
            axum::http::HeaderValue::from_static("nosniff"),
        ))
        .layer(SetResponseHeaderLayer::overriding(
            axum::http::header::X_FRAME_OPTIONS,
            axum::http::HeaderValue::from_static("DENY"),
        ));

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
