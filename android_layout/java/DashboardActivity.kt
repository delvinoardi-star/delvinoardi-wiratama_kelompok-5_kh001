package com.example.praktikum3

import android.os.Bundle
import android.widget.Button
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity

class DashboardActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_dashboard)

        val menu = mapOf(R.id.btnProfil to "Profil", R.id.btnNilai to "Nilai", R.id.btnJadwal to "Jadwal")
        for ((id, nama) in menu) {
            findViewById<Button>(id).setOnClickListener {
                Toast.makeText(this, "Menu $nama dipilih", Toast.LENGTH_SHORT).show()
            }
        }
    }
}
