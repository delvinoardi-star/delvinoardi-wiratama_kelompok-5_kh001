package com.example.praktikum3

import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity

class RegistrationActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_registration)

        val etUsername = findViewById<EditText>(R.id.etUsername)
        val etEmail = findViewById<EditText>(R.id.etEmail)
        val etPassword = findViewById<EditText>(R.id.etPassword)

        findViewById<Button>(R.id.btnBantuan).setOnClickListener {
            Toast.makeText(this, "Password minimal 8 karakter", Toast.LENGTH_SHORT).show()
        }

        findViewById<Button>(R.id.btnRegister).setOnClickListener {
            if (etUsername.text.isBlank() || etEmail.text.isBlank() || etPassword.text.isBlank()) {
                Toast.makeText(this, "Semua kolom wajib diisi", Toast.LENGTH_SHORT).show()
            } else {
                Toast.makeText(this, "Akun ${etUsername.text} berhasil didaftarkan", Toast.LENGTH_SHORT).show()
            }
        }
    }
}
