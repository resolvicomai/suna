# Health check endpoint for Railway
from fastapi import APIRouter, HTTPException
from datetime import datetime
import os
import psutil
import redis as redis_client
from services.supabase import DBConnection
from utils.logger import logger

router = APIRouter()

@router.get("/health")
async def health_check():
    """
    Comprehensive health check for Railway deployment
    """
    health_status = {
        "status": "healthy",
        "timestamp": datetime.utcnow().isoformat(),
        "version": os.getenv("APP_VERSION", "1.0.0"),
        "environment": os.getenv("NODE_ENV", "production"),
        "checks": {}
    }
    
    try:
        # Check system resources
        health_status["checks"]["memory"] = {
            "status": "ok",
            "usage_percent": psutil.virtual_memory().percent
        }
        
        health_status["checks"]["disk"] = {
            "status": "ok", 
            "usage_percent": psutil.disk_usage('/').percent
        }
        
        # Check Redis connection
        try:
            redis_url = os.getenv("REDIS_URL", "redis://localhost:6379")
            redis_conn = redis_client.from_url(redis_url)
            redis_conn.ping()
            health_status["checks"]["redis"] = {"status": "ok"}
        except Exception as e:
            health_status["checks"]["redis"] = {
                "status": "error",
                "message": str(e)
            }
            health_status["status"] = "degraded"
        
        # Check Supabase connection
        try:
            db = DBConnection()
            client = await db.client
            # Simple query to test connection
            result = await client.from_('agent_runs').select('id').limit(1).execute()
            health_status["checks"]["database"] = {"status": "ok"}
        except Exception as e:
            health_status["checks"]["database"] = {
                "status": "error", 
                "message": str(e)
            }
            health_status["status"] = "degraded"
            
        # Return appropriate status code
        if health_status["status"] == "healthy":
            return health_status
        else:
            raise HTTPException(status_code=503, detail=health_status)
            
    except Exception as e:
        logger.error(f"Health check failed: {str(e)}")
        raise HTTPException(
            status_code=503,
            detail={
                "status": "unhealthy",
                "timestamp": datetime.utcnow().isoformat(),
                "error": str(e)
            }
        )