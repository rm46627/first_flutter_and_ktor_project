package com.example.mynotes.email

import com.example.mynotes.security.email.Message
import jakarta.mail.internet.MimeMessage
import org.springframework.mail.javamail.JavaMailSender
import org.springframework.mail.javamail.MimeMessageHelper
import org.springframework.stereotype.Service
import org.thymeleaf.TemplateEngine
import org.thymeleaf.context.Context

@Service
class MailService(
    private val messageSender: JavaMailSender,
    private val templateEngine: TemplateEngine
) {
    fun sendMail(email: Message) {
        val msg = createMessage(email)
        messageSender.send(msg)
    }

    private fun createMessage(email: Message): MimeMessage {
        val message: MimeMessage = messageSender.createMimeMessage()
        val helper = MimeMessageHelper(message)

        setupMessage(helper, email)

        return message
    }

    private fun setupMessage(helper: MimeMessageHelper, email: Message) {
        helper.setTo(email.to)
        helper.setFrom("mynotes@flutterApp.com")
        helper.setSubject(email.subject)
        helper.setText(build(email.text))
    }

    fun build(message: String): String {
        val context = Context()
        context.setVariable("message", message)
        return templateEngine.process("mailTemplate", context)
    }
}