import streamlit as st
import pandas as pd
import plotly.express as px
import time

st.set_page_config(page_title="Tablespace Usage Dashboard", layout="wide")

st.title("📊 Oracle Tablespace Usage Dashboard")

# Force-bypass GitHub CDN cache using timestamp
CSV_URL = f"https://raw.githubusercontent.com/krithiksundar/Project_DB_ETL/main/ts_usage.csv?t={int(time.time())}"

# Load always-fresh CSV
try:
    df = pd.read_csv(CSV_URL)

    st.subheader("📄 Raw Data (Live from GitHub)")
    st.dataframe(df, use_container_width=True)

    # Validate required columns
    required_cols = {"TABLESPACE_NAME", "USED_MB"}

    if not required_cols.issubset(df.columns):
        st.error(f"CSV must contain columns: {', '.join(required_cols)}")
    else:
        st.subheader("🥧 Tablespace Used Space Pie Chart")
        fig = px.pie(
            df,
            names="TABLESPACE_NAME",
            values="USED_MB",
            title="Tablespace Used Space (MB)",
            hole=0.4
        )
        st.plotly_chart(fig, use_container_width=True)

except Exception as e:
    st.error(f"Error loading CSV from GitHub: {e}")
